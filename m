Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23523 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaIASyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 14:54:07 -0400
Date: Mon, 1 Sep 2014 21:53:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Avinash Patil <patila@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mwifiex: parse TDLS action frames during RX
Message-ID: <20140901185336.GD6549@mwanda> (sfid-20140901_205410_568791_4A56ABBA)
References: <20140828132352.GD24477@mwanda>
 <CBACCFA0AEB13A41977475BCF3E896FC4781147CC8@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC4781147CC8@SC-VEXCH2.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 01, 2014 at 12:33:36AM -0700, Avinash Patil wrote:
> Hi Dan,
> 
> Thanks for reporting static checker warning.
> Patch has been submitted which ensures we do not copy beyond end.
> 

Great!  Thanks!  Do you have a link to the patch?

regards,
dan carpenter

