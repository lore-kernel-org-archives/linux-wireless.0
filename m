Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4902 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab3HVIJB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 04:09:01 -0400
Message-ID: <5215C710.7050703@broadcom.com> (sfid-20130822_100910_326631_47E90AB3)
Date: Thu, 22 Aug 2013 10:08:48 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Jonas Gorski" <jogo@openwrt.org>,
	"David Herrmann" <dh.herrmann@gmail.com>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: Re: [RFT V2 02/13] brcmsmac: change pa_gain for bcm4313 iPA
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
 <1376424220-10765-3-git-send-email-arend@broadcom.com>
 <52151297.5010706@hauke-m.de>
In-Reply-To: <52151297.5010706@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/21/2013 09:18 PM, Hauke Mehrtens wrote:
> Hi Arend,
>
> when you send a new patch please fix this typo.

Got it covered already:

http://mid.gmane.org/1377007246-9957-3-git-send-email-arend@broadcom.com

Regards,
Arend

> Hauke
>
> On 08/13/2013 10:03 PM, Arend van Spriel wrote:
>> The function wlc_lcnphy_load_tx_gain_table() has a target PA
>> gain specified for the iPA variant of the bcm4313. This gain
>> value is reduced to avoid PA distortion. The if-statement is
>> removed because it was rather redundant in the first place.
>> Please not that this patch does not provide full iPA support.
>           ^^^
>           note
>
>
>


