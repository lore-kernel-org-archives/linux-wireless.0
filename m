Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 42.248.sfcn.org ([160.7.248.42]:44473 "HELO mail.mypals.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750812AbZEGEAZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 00:00:25 -0400
From: Alf <alf@mypals.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: ath5k in 2.6.29.1 won't associate with AP
Date: Wed, 6 May 2009 22:00:26 -0600
Cc: Bob Copeland <me@bobcopeland.com>,
	Tulio Magno Quites Machado Filho <tuliom@quites.com.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200905021218.23747.alf@mypals.org> <200905052142.38780.alf@mypals.org> <40f31dec0905060454s513c5eeas44389e6527eed1fd@mail.gmail.com>
In-Reply-To: <40f31dec0905060454s513c5eeas44389e6527eed1fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200905062200.26857.alf@mypals.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 May 2009 05:54:13 am Nick Kossifidis wrote:
> Can you please post the full dmesg output when ath5k loads ?

This is with debugging turned on.

========== dmesg ==========
15:43:35 ath5k 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18         
15:43:35 ath5k 0000:00:07.0: registered as 'phy0'                               
15:43:35 phy0: Selected rate control algorithm 'minstrel'                       
15:43:35 ath5k phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)           
15:43:39 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1                      
15:43:39 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2                      
15:43:39 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3                      
15:43:39 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out                  
15:43:50 wlan0: authenticate with AP 00:30:bd:60:d3:44                          
15:43:50 wlan0: authenticate with AP 00:30:bd:60:d3:44                          
15:43:50 wlan0: authenticate with AP 00:30:bd:60:d3:44                          
15:43:51 wlan0: authentication with AP 00:30:bd:60:d3:44 timed out              
15:44:01 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1                      
15:44:01 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2                      
15:44:02 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3                      
15:44:02 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out                  
15:44:12 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1                      
15:44:12 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2                      
15:44:13 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3                      
15:44:13 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out                  
15:44:29 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1                      
15:44:29 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1                      
15:44:30 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2                      
15:44:30 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3                      
15:44:30 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out                  
15:44:47 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1                      
15:44:47 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1                      
15:44:47 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2                      
15:44:47 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
15:44:47 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out
15:44:55 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
15:44:55 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2
15:44:55 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
15:44:56 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out
15:45:05 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
15:45:05 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
15:45:05 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
15:45:05 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2
15:45:05 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
15:45:06 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out
15:45:16 wlan0: authenticate with AP 00:30:bd:60:d3:44
15:45:16 wlan0: authenticate with AP 00:30:bd:60:d3:44
15:45:16 wlan0: authenticate with AP 00:30:bd:60:d3:44
15:45:17 wlan0: authenticate with AP 00:30:bd:60:d3:44
15:45:17 wlan0: authentication with AP 00:30:bd:60:d3:44 timed out
15:45:34 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
15:45:34 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
15:45:35 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2
15:45:35 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
15:45:35 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out
15:45:46 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
15:45:46 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
15:45:46 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2
15:45:46 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
15:45:46 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out
======== end dmesg ========

-- 
Alf
@
