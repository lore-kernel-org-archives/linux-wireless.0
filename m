Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:45635 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZDWJyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 05:54:25 -0400
MIME-Version: 1.0
In-Reply-To: <49EEF38D.8000801@in.ibm.com>
References: <20090422154247.dbffd285.sfr@canb.auug.org.au>
	 <49EEF38D.8000801@in.ibm.com>
Date: Thu, 23 Apr 2009 13:54:24 +0400
Message-ID: <a4423d670904230254v672798ddtda443e549ef45490@mail.gmail.com> (sfid-20090423_115431_318442_14FEF8ED)
Subject: Re: April 22 Next : net/rfkill randconfig failure
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Sachin Sant <sachinp@in.ibm.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/22 Sachin Sant <sachinp@in.ibm.com>:
> Today's next tree build (x86 randconfig) failed with
>
> net/rfkill/rfkill.c: In function 'update_rfkill_state':
> net/rfkill/rfkill.c:99: error: implicit declaration of function
> 'rfkill_led_trigger'
> make[2]: *** [net/rfkill/rfkill.o] Error 1
>
> .config attached
>

Add CCs
