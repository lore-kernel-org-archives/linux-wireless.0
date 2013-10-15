Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50165 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757896Ab3JOKwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 06:52:08 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Sander Eikelenboom <linux@eikelenboom.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [Ilw] drivers/net/wireless/iwlwifi/dvm/tx.c:456
	iwlagn_tx_skb+0x6c5/0x883()
Date: Tue, 15 Oct 2013 10:52:04 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DC46E5@HASMSX103.ger.corp.intel.com> (sfid-20131015_125211_956166_4285EF34)
References: <9010061839.20131015123940@eikelenboom.it>
In-Reply-To: <9010061839.20131015123940@eikelenboom.it>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Hi,
> 
> I'm having a:
> 
> 02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6235 (rev
> 24)
> 
> And i'm running into this warning on boot with a 3.11.2 and 3.12-rc5 kernel.
> 
> [   23.904950] ------------[ cut here ]------------
> [   23.904957] WARNING: CPU: 0 PID: 2531 at
> drivers/net/wireless/iwlwifi/dvm/tx.c:456 iwlagn_tx_skb+0x6c5/0x883()

Can you reproduce easily?
If yes, please reproduce with debug parameters:
modprobe iwlwifi debug=0xC0800000

Also, please enable MAC80211_HT_DEBUG

Thanks

