Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48175 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3HUTS6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 15:18:58 -0400
Message-ID: <52151297.5010706@hauke-m.de> (sfid-20130821_211901_186226_AFA907D3)
Date: Wed, 21 Aug 2013 21:18:47 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Jonas Gorski <jogo@openwrt.org>,
	David Herrmann <dh.herrmann@gmail.com>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	David Costa <david@zarel.net>
Subject: Re: [RFT V2 02/13] brcmsmac: change pa_gain for bcm4313 iPA
References: <1376424220-10765-1-git-send-email-arend@broadcom.com> <1376424220-10765-3-git-send-email-arend@broadcom.com>
In-Reply-To: <1376424220-10765-3-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

when you send a new patch please fix this typo.

Hauke

On 08/13/2013 10:03 PM, Arend van Spriel wrote:
> The function wlc_lcnphy_load_tx_gain_table() has a target PA
> gain specified for the iPA variant of the bcm4313. This gain
> value is reduced to avoid PA distortion. The if-statement is
> removed because it was rather redundant in the first place.
> Please not that this patch does not provide full iPA support.
         ^^^
         note


