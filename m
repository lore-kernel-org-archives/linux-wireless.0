Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:36333 "EHLO
	spunkymail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753831AbZEVNsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 09:48:07 -0400
Message-ID: <4A16AD12.2020200@hiramoto.org>
Date: Fri, 22 May 2009 15:48:02 +0200
From: Karl Hiramoto <karl@hiramoto.org>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] hostapd not sending beacons, and no traffic.
References: <4A168B8A.4070609@hiramoto.org>
In-Reply-To: <4A168B8A.4070609@hiramoto.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

more info on this enabling debug in ath9k

ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
ath9k: receive FIFO overrun interrupt                            
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071
ath9k: new IMR 0x918104b4
ath9k: enable IER
ath9k: AR_IMR 0x918104b4 IER 0x1
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT

