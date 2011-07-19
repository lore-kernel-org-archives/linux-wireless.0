Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:45256 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1GSPpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 11:45:54 -0400
Received: by fxd18 with SMTP id 18so213471fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 08:45:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311089451.2647.1.camel@dcbw.foobar.com>
References: <20110717170325.8ABB09D401C@zog.reactivated.net>
	<1311089451.2647.1.camel@dcbw.foobar.com>
Date: Tue, 19 Jul 2011 16:45:53 +0100
Message-ID: <CAGq3pz5rniWzM86ETz4A9THCjfwDxq7mJewb4rVYgjwNQUiFcg@mail.gmail.com> (sfid-20110719_174557_824065_A6C7D9DD)
Subject: Re: [PATCH 2/4] libertas: mesh: misc cleanup
From: Daniel Drake <dsd@laptop.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 July 2011 16:30, Dan Williams <dcbw@redhat.com> wrote:
> On Sun, 2011-07-17 at 18:03 +0100, Daniel Drake wrote:
>> Remove unused blindlist code.
>
> The blind list stuff was to enable easier testing of the mesh
> functionality in an automated fashion; are you guys not using that?  I'm
> fine with removing it for now if it's not actually being used by OLPC.

It's definitely not being used - it is dead code, not accessible from anywhere.
I guess this was originally a private ioctl.

We don't actively work on the mesh as before, we are just sticking
with the current implementation. If that ever were to change I guess
we could find a way to add this code in again, but I don't see that
being likely.

Thanks,
Daniel
