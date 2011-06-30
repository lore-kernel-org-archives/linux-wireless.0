Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3906 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1F3G7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 02:59:47 -0400
Message-ID: <4E0C1ED3.4030200@broadcom.com> (sfid-20110630_085951_631676_BEE840DF)
Date: Thu, 30 Jun 2011 08:59:31 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>
Subject: Re: [PATCH 000/119] staging: brcm80211: more code cleanup and
 bug fixed
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <BANLkTikPBWvYiNc1rZEwPJTck=AzUsLncA@mail.gmail.com>
In-Reply-To: <BANLkTikPBWvYiNc1rZEwPJTck=AzUsLncA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2011 08:29 AM, Rafał Miłecki wrote:
> 2011/6/30 Franky Lin<frankyl@broadcom.com>:
>> Most of these patches are brcmfmac cleanup.
>
> Hm, interesting improvement in your "Release early, release often" strategy.

Hi, Rafał

We are aware and it was not preferred way to do this. Due to lot of 
renaming and (re)moving code we queued it up internally to make sure 
dependent patches would apply without major hassle. The staging-next 
tree did not move since beginning of June so it became quite a large 
patch queue.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


