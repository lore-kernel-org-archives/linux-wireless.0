Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59972 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab1FAQ2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 12:28:46 -0400
Received: by qyg14 with SMTP id 14so3083530qyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 09:28:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE6678F.1020803@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
	<BANLkTinwvwauMOMXiFnUTnDonfB2oSxdRw@mail.gmail.com>
	<4DE6678F.1020803@broadcom.com>
Date: Wed, 1 Jun 2011 18:28:45 +0200
Message-ID: <BANLkTi=6P=2qbf9mkuH5PL5TnpYu8q4-bw@mail.gmail.com> (sfid-20110601_182849_695090_2D771249)
Subject: Re: [PATCH 01/83] staging: brcm80211: removed unused Broadcom
 specific ioctls codes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 1 czerwca 2011 18:23 użytkownik Henry Ptasinski
<henryp@broadcom.com> napisał:
> On 06/01/2011 04:59 AM, Rafał Miłecki wrote:
>>
>> 2011/6/1 Roland Vossen<rvossen@broadcom.com>:
>>>
>>> Code cleanup. Removal of code that is not invoked.
>>
>> Have you heard of "Release early, release often"? It's something, we
>> like here...
>
> These are all changes that piled up during the merge window.
>
> We had some issues previously with patch dependencies when sending patches
> out early and often, so we're trying to organize the patches a little
> better.  Perhaps we went a little to far with this set.  We'll try to find a
> better balance in the future.

Yeah, merge window is something ugly for development :( I got already
lost with my bcma/b43 patches and I'm just waiting for John to start
grabbing old patches.

John, wireless guys: did you ever consider creating some tree open
during merge window? Something like to-become-wireless-next?

-- 
Rafał
