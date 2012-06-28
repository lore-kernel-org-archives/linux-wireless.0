Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4439 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2F1Gqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 02:46:39 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20459.64903.329882.547190@gargle.gargle.HOWL> (sfid-20120628_084643_166393_8B61F29A)
Date: Thu, 28 Jun 2012 12:15:27 +0530
To: Guido Iribarren <guidoiribarren@buenosaireslibre.org>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Re: Regression on ath9k_htc managed mode
In-Reply-To: <CAHD-aqL9tW_rF3V0-_FX4erdyZE8vNYr+d=dShptRbePaXN_JQ@mail.gmail.com>
References: <CAHD-aq+nNs4L0iZNxYSABX-1Wk+B=s-Avqc1TFYfO-8JOOZ5kA@mail.gmail.com>
	<20455.47109.203396.141311@gargle.gargle.HOWL>
	<CAHD-aqL9tW_rF3V0-_FX4erdyZE8vNYr+d=dShptRbePaXN_JQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guido Iribarren wrote:
> thanks for the patch, i found it strange because it seems related to
> IBSS, but i just tried it anyway
> unfortunately it didn't solve the problem :(
> 
> Please note the bug I described happens when in client (managed) mode,
> and it is in fact a regression because it was working fine on 2012-02-27
> 
> something along the development up to 2012-04-13 caused the bug

You had mentioned earlier that you were recompiling OpenWRT for bisecting,
are you using an AP running OpenWRT ? On what platform is the dongle being used ?

Sujith
