Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3525 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab1LIK2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 05:28:09 -0500
Message-ID: <4EE1E2AC.8030002@broadcom.com> (sfid-20111209_112822_109668_7860A322)
Date: Fri, 9 Dec 2011 11:27:56 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Francesco Gringoli" <francesco.gringoli@ing.unibs.it>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Performance of BCM43224 (14e4:4353)
References: <4EE15A4E.1090500@lwfinger.net>
In-Reply-To: <4EE15A4E.1090500@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2011 01:46 AM, Larry Finger wrote:
> Guys,
> 
> I just added the patches that let brcmsmac use bcma, and tested the TX and RX 
> rates using netperf. The results are
> 
> Driver			RX		TX
> 
> brcmsmac		21.7		6.2
> b43			15.0		6.0
> wl			43.5		73.5
> 

Hi Larry

Could you perform your benchmark test on brcmsmac without the bcma
patches. It kind of surprises me that we are that far off compared to
the wl driver.

Gr. AvS


