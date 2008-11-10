Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23105.mail.ird.yahoo.com ([217.146.189.45]:46791 "HELO
	web23105.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754711AbYKJVzn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 16:55:43 -0500
Date: Mon, 10 Nov 2008 21:55:40 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: throughput problem Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <200811101936.49887.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <301990.42064.qm@web23105.mail.ird.yahoo.com> (sfid-20081110_225601_318643_8618A9FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Mon, 10/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> Here I don't get such low transfer rate, may be a
> regression in 
> wireless-testing? Try a bisect to see, besides that I
> don't have other ideas 
> what could be. BTW, do you checked wireless-testing, so can
> I add your 
> tested-by then to the "feedback transmitted
> packets..."  patch? I plan to 
> submit the final patch to inclusion in wireless-testing
> soon.

Yes, I suppose I'll need to go the git bisect route to find out what's wrong with the throughput. The "feedback transmitted packets" patch is
good - have it with wireless testing - please send it in with tested-by.

Hin-Tak  


      
