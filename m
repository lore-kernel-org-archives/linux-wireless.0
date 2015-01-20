Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:60725 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbbATKO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 05:14:59 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: wil6210: ADDBA/DELBA flows
Date: Tue, 20 Jan 2015 12:14:51 +0200
Message-ID: <1470771.bfDeIoVyDF@lx-wigig-72> (sfid-20150120_111502_816254_120EAA26)
In-Reply-To: <20150119145332.GA19489@mwanda>
References: <20150119145332.GA19489@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, January 19, 2015 05:53:32 PM Dan Carpenter wrote:
> The patch 3277213feb1b: "wil6210: ADDBA/DELBA flows" from Dec 23,
> 2014, leads to the following static checker warning:
> 
>         drivers/net/wireless/ath/wil6210/rx_reorder.c:205 wil_tid_ampdu_rx_alloc()
>         error: scheduling with locks held: 'spin_lock:tid_rx_lock'
> 

Dan, thanks for finding this. Will submit patch shortly

Thanks, Vladimir
