Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm28-vm2.bullet.mail.sg3.yahoo.com ([106.10.151.145]:25490 "EHLO
	nm28-vm2.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbaDED23 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 23:28:29 -0400
Message-ID: <1396668507.37072.YahooMailBasic@web193504.mail.sg3.yahoo.com> (sfid-20140405_052850_140701_32537910)
Date: Sat, 5 Apr 2014 11:28:27 +0800 (SGT)
From: sandeep suresh <sandeep.suresh@yahoo.co.in>
Subject: RE: [ath9k-devel] Wifi client Bluetooth coexistence; non smooth video streams
To: =?utf-8?B?6ams5paH5rab?= <xmgwinner@hotmail.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <BLU173-W327CA400B077F070C3A04FB46F0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello Mr.马文涛,
    Thanks for your suggestions....will try and let u know the results.
Regards
Sandeep.

--------------------------------------------
On Fri, 4/4/14, 马文涛 <xmgwinner@hotmail.com> wrote:

 Subject: RE: [ath9k-devel] Wifi client Bluetooth coexistence; non smooth video streams
 To: "sandeep suresh" <sandeep.suresh@yahoo.co.in>
 Date: Friday, 4 April, 2014, 11:59 PM
 
 
 
 
 Hi sandeep,
 I never used wifi just like you. So I only have
 some advices for you.1. Video needs more
 throughput, so 7:3 or 8:2 seams better.2. If you
 use RTSP to transmit video, I guess you can short the switch
 time to reduce the delay. Just try to set period to
 100ms or less for test. I think it will be
 better. 
 
 
 > Date: Fri, 4 Apr 2014 09:55:40 +0800
 > From: sandeep.suresh@yahoo.co.in
 > To: adrian@freebsd.org; ath9k-devel@lists.ath9k.org;
 linux-wireless@vger.kernel.org
 > Subject: [ath9k-devel] Wifi client Bluetooth
 coexistence;	non smooth video streams
 > 
 > Dear all,
 >    Please help if any one have encountered simillar
 problems or other guidance on this, Please.
 > 
 > The following is my set-up:
 > Linksys Access point. Cisco 802.11g camera connected as
 a wifi client to Linksys. I have a development board in
 which i have AR9287 as the Wifi chipset associated as wifi
 client to linksys. The development board has Bluetooth
 dongle for streaming audio etc. The development board has a
 LCD display and I stream the video stream from camera at 640
 x 480 resolution, MPEG-4, 10fps (also tried with 15, 30
 fps).
 > 
 > Software: For the Wifi client on the development board,
 I am using the ath9k driver with btcoex_enable=1.
 > 2-wire coexistence. I am allowing 40% of the time for
 Bluetooth an 60% of the time for WiFi. The period is around
 200ms.
 > 
 > Observations: 
 > 1. The video streams are not smooth. There will be a
 small pause of a second or two between frames and hence we
 do not see smooth transitions.
 > 2. Sometimes it looks like, the streams are bufferred
 and played back at a rapid pace. So, one can see like a fast
 forward play of video streams on the board.
 > 3. Disabling coexistence does not have these
 observations.
 > Please help.
 > Regards
 > Sandeep.
 > _______________________________________________
 > ath9k-devel mailing list
 > ath9k-devel@lists.ath9k.org
 > https://lists.ath9k.org/mailman/listinfo/ath9k-devel
  		 	   		  
 
