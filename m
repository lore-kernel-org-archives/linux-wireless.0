Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:41303 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbFCASY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 20:18:24 -0400
From: "Li, Yanbo" <yanbol@qca.qualcomm.com>
To: =?iso-8859-2?Q?Jakub_Kici=F1ski?= <moorray3@wp.pl>
CC: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"dreamfly281@gmail.com" <dreamfly281@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] ath10k: Debugfs entry to enable/disable WLAN&Blutooth
 Coexist feature
Date: Wed, 3 Jun 2015 00:18:01 +0000
Message-ID: <641f79bf066d48b1b79f21a24eb0d0e2@nasanexm02e.na.qualcomm.com> (sfid-20150603_021828_271404_AA5EECD9)
References: <1432840745-21725-1-git-send-email-yanbol@qca.qualcomm.com>
 <20150602113901.2da3542d@north>
In-Reply-To: <20150602113901.2da3542d@north>
Content-Type: text/plain; charset="iso-8859-2"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Jakub Kiciñski [mailto:moorray3@wp.pl]
> Sent: Tuesday, June 02, 2015 2:39 AM
> To: Li, Yanbo
> Cc: Valo, Kalle; dreamfly281@gmail.com; ath10k@lists.infradead.org; linux-
> wireless@vger.kernel.org
> Subject: Re: [PATCH v2] ath10k: Debugfs entry to enable/disable
> WLAN&Blutooth Coexist feature
> 
> On Thu, 28 May 2015 12:19:05 -0700, Yanbo Li wrote:
> > As some radio have no connection with BT modules, enable the
> > WLAN/Bluetooth
> > coexist(BTC) feature will has some side effect if the radio's GPIO
> > connect with any other HW modules. Add the control switcher
> > "btc_feature" at debugfs and set the feature as disable by default to avoid
> such case.
> >
> > To enable this feature, execute:
> > echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
> > To disable:
> > echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
> >
> > Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
> 
> IMHO common API for disabling/enabling btcoex is something we would all
> benefit from and easy enough to implement properly.  Burying it in driver-
> specific debugfs is less than appropriate.
> 
> I seem to recall there were plans to discuss btcoex at one of the linux-
> wireless summits.  If the consensus was to leave it in debugfs then I
> apologize for the noise ;)

Thanks for your comments, agree with a general BTcoex interface will be good for lots of wlan chip/driver. 
It worth to be consider to implement such framework in future.

BR /Yanbo
