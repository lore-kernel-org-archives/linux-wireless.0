Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53504 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758515AbYFDXKD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 19:10:03 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1K427G-0004jf-C4
	for linux-wireless@vger.kernel.org; Wed, 04 Jun 2008 23:10:02 +0000
Received: from cpc1-cwma5-0-0-cust137.swan.cable.ntl.com ([80.4.12.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 23:10:02 +0000
Received: from sitsofe by cpc1-cwma5-0-0-cust137.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 23:10:02 +0000
To: linux-wireless@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: hostap now defaults to monitor mode? (SOLVED)
Date: Thu, 05 Jun 2008 00:05:34 +0100
Message-ID: <g2773s$a50$1@ger.gmane.org> (sfid-20080605_011007_599151_06017A9B)
References: <g274cq$2sn$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sitsofe Wheeler wrote:

> On linux-next-20080604 hostap seems to default to monitor mode breaking
> scripts that expect it to be in managed mode by default. Has hostap always
> defaulted to monitor mode? I can't see a patch in the Ubuntu kernel tree
> to change this...

My bad. Ubuntu changes the default in the module options and on the kernels
I compile hostap is built in. Apologies for the spam.

-- 
Sitsofe | http://sucs.org/~sits/

