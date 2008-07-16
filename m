Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:37686 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYGPOiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 10:38:17 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] Merge tx/rx descriptor flags of rtl818x devices
Date: Wed, 16 Jul 2008 11:38:26 -0300
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
References: <200807111656.40342.herton@mandriva.com.br> <200807160211.22995.flamingice@sourmilk.net>
In-Reply-To: <200807160211.22995.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807161138.27221.herton@mandriva.com.br> (sfid-20080716_163821_635308_D95B8FD9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Wednesday 16 July 2008 03:11:18 Michael Wu escreveu:
> On Friday 11 July 2008 15:56:39 Herton Ronaldo Krzesinski wrote:
> > In rtl818x code tx/rx descriptor flags are common between all devices as
> > far as I could check (looking at r8180 specs I found on the web recently
> > and on vendor rtl8187b driver). Here is a proposal for merging them:
> Go ahead and s/[RFC]/[PATCH]/ if you've made sure the numbers are the same and 
> tested. This is a good idea.
> 
> -Michael Wu
> 

Ok, I'll repost the patch soon.

-- 
[]'s
Herton
