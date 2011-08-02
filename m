Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57393 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab1HBUJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 16:09:40 -0400
Received: by fxh19 with SMTP id 19so146910fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 13:09:39 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH 1/2] libertas: add ability to power off card on suspend
Date: Tue, 2 Aug 2011 23:09:07 +0300
Cc: libertas-dev@lists.infradead.org, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
References: <201108021312.23153.anarsoul@gmail.com> <1312280832-27675-1-git-send-email-anarsoul@gmail.com> <CAGq3pz4bQ_2eQbVye==3Xqq3gK4PV6+JJXoHX0TXz=Y7kWC0wQ@mail.gmail.com>
In-Reply-To: <CAGq3pz4bQ_2eQbVye==3Xqq3gK4PV6+JJXoHX0TXz=Y7kWC0wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108022309.07783.anarsoul@gmail.com> (sfid-20110802_221011_076782_DDED89DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 August 2011 13:54:07 Daniel Drake wrote:
> On 2 August 2011 11:27, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> > Could be usefull if it's not possible to keep power on the card
> > when host goes into suspend.
> 
> If it's not possible to keep power during suspend, then I don't see
> why you need to explicitly turn it off on the way down.

Because no one puts interface down before suspend?
I just re-tested - if interface is up - kernel does not put it down before 
suspend, so I got a lot of timeouts and errors on dmesg after resume.

Regards
Vasily
