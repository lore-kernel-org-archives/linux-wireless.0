Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:50460 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab3ICMxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 08:53:04 -0400
Received: by mail-bk0-f43.google.com with SMTP id mz13so2067961bkb.16
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 05:53:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7f4ff1930bfc4f3b8160b1595950c5a1@THHSTE15D1BE3.hs20.net>
References: <7f4ff1930bfc4f3b8160b1595950c5a1@THHSTE15D1BE3.hs20.net>
Date: Tue, 3 Sep 2013 14:53:01 +0200
Message-ID: <CA+BoTQn7nhsDxedekMTZ9ZqFyo55zR3iGPuTYvVqELGYGh5njg@mail.gmail.com> (sfid-20130903_145308_382040_A097A9FC)
Subject: Re: ACS compile to hostapd 2.0
From: Michal Kazior <michal.kazior@tieto.com>
To: Andrew Delamare <andrew.delamare@powerethernet.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 September 2013 14:33, Andrew Delamare
<andrew.delamare@powerethernet.com> wrote:
> Hey there,
>
> So I want to get ACS working and I have looked at your ACS page at: http://wireless.kernel.org/en/users/Documentation/acs
>
> I found there is a patchset that you can use with the ACS code that patches a standard hostapd. So I tried this patch and I am having issues getting ACS to patch into hostapd 2.0. What is the code strand that this patch works on?

Hi,

ACS has been merged into hostapd master branch 3 days ago so you can
try pulling that.

The patch on the aforementioned page probably doesn't apply on a 2.0
release as-is.


Michał.
