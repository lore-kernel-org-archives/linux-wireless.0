Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:44508 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab3BAKIz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 05:08:55 -0500
Message-ID: <510B942D.5000403@neratec.com> (sfid-20130201_110859_076914_ECBD370F)
Date: Fri, 01 Feb 2013 11:08:45 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection command/event
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de> <5107D345.7010101@neratec.com> <20130129143652.GA23425@pandem0nium> <5109094C.8050703@neratec.com> <20130130162531.GA27532@pandem0nium> <510A30D1.2080604@neratec.com> <20130131175429.GD2018@pandem0nium>
In-Reply-To: <20130131175429.GD2018@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note: removed folks from CC to reduce noise
On 01/31/2013 06:54 PM, Simon Wunderlich wrote:
> Hey Zefir,
> [...]
> 
> Thanks a lot! I've got quite a few mails of people offering their help to check
> and verify this implementation or test it in their country. :) If you want to
> help in the integration for ath9k, I'd be glad ... the interface should be
> rather simple so maybe we don't have too much hassle? I have a little patch for
> ath9k to add dummy radar support and simulate events etc as baseline, if you
> (or anyone else) is interested ...
> 
I am currently bound to another project (interference detection based on
ath9k-spectral ;)), but since I started integration once long ago based on
Victor's initial interface proposal, I might take a look again (if noone else
wants to try).

Do you have the updated driver interface ready?

> Cheers,
> 	Simon
> 

