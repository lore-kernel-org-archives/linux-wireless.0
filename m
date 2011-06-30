Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52057 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1F3G3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 02:29:52 -0400
Received: by pzk9 with SMTP id 9so1440875pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 23:29:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
Date: Thu, 30 Jun 2011 08:29:51 +0200
Message-ID: <BANLkTikPBWvYiNc1rZEwPJTck=AzUsLncA@mail.gmail.com> (sfid-20110630_082959_415699_22559368)
Subject: Re: [PATCH 000/119] staging: brcm80211: more code cleanup and bug fixed
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Franky Lin <frankyl@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org,
	Roland Vossen <rvossen@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/30 Franky Lin <frankyl@broadcom.com>:
> Most of these patches are brcmfmac cleanup.


Hm, interesting improvement in your "Release early, release often" strategy.


---------- Wiadomość przekazana dalej ----------
Od: Henry Ptasinski <henryp@broadcom.com>
Data: 1 czerwca 2011 18:23
Temat: Re: [PATCH 01/83] staging: brcm80211: removed unused Broadcom
specific ioctls codes

On 06/01/2011 04:59 AM, Rafał Miłecki wrote:
>
> 2011/6/1 Roland Vossen<rvossen@broadcom.com>:
>>
>> Code cleanup. Removal of code that is not invoked.
>
> Have you heard of "Release early, release often"? It's something, we
> like here...

These are all changes that piled up during the merge window.

We had some issues previously with patch dependencies when sending
patches out early and often, so we're trying to organize the patches a
little better.  Perhaps we went a little to far with this set.  We'll
try to find a better balance in the future.
