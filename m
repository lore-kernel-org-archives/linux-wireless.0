Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59595 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab2F0MSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 08:18:44 -0400
Received: by werb10 with SMTP id b10so219632wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 05:18:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FEAC62F.4000400@broadcom.com>
References: <4FE886B3.7020202@lwfinger.net>
	<4FEAC62F.4000400@broadcom.com>
Date: Wed, 27 Jun 2012 14:18:43 +0200
Message-ID: <CACna6ryNb6_DTcZJhK9QEX8U2F+C3JbtVeBaTXAuPQ0hL5cjqw@mail.gmail.com> (sfid-20120627_141847_992130_BDB3E76F)
Subject: Re: Question about BCM43228 and outdated description in MAINTAINERS
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/27 Arend van Spriel <arend@broadcom.com>:
>> Reverse engineering this device to be able to drive it with b43 would
>> involve a lot of effort. If your group is planning on adding it to
>> brcmsmac, then I would not undertake this project. To the fullest extent
>> that you can, please advise me regarding this matter.
>
> Our focus is currently on extending brcmfmac. We had requests for 43228
> support before, but did not start that task. Will inform internally what
> the plan is here and let you know to the fullest extent ;-)

Can you ask about BCM4331? It's probably the most desired code (HT
PHY) across embedded devices.

-- 
Rafał
