Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaKBM2e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2014 07:28:34 -0500
Date: Sun, 2 Nov 2014 13:25:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: 3.18-rc0: iwlegacy failed after a while
Message-ID: <20141102122544.GA9242@redhat.com> (sfid-20141102_132854_466293_31C0EAC8)
References: <0BA3FCBA62E2DC44AF3030971E174FB31B552E3F@hasmsx107.ger.corp.intel.com>
 <20141024121240.GA3177@redhat.com>
 <20141025114246.GA16230@amd>
 <20141026103314.GB2588@redhat.com>
 <20141026110554.GA1634@amd>
 <20141028222014.GA27961@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141028222014.GA27961@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2014 at 11:20:15PM +0100, Pavel Machek wrote:
> > > It can be checked by "iw dev wlan0 get power_save" .
> 
> So it seems I have power save on. I guess someone enabled it for me :-).
> 
> root@duo:~# iwconfig wlan0
> wlan0     IEEE 802.11abg  ESSID:off/any  
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=15 dBm   
>           Retry short limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:on
>           
> root@duo:~# iw dev wlan0 get power_save
> Power save: on
> root@duo:~# 

Could you confirm that problem happen with power save on and do not
happen without it ?

Stanislaw

