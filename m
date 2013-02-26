Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64600 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3BZIWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 03:22:42 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <linville@tuxdriver.com>, <yongjun_wei@trendmicro.com.cn>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH -next] wil6210: convert to use simple_open()
Date: Tue, 26 Feb 2013 10:22:37 +0200
Message-ID: <7372753.nvs2UvHyrD@lx-vladimir> (sfid-20130226_092251_736511_4203D333)
In-Reply-To: <CAPgLHd-bG936v1J73Ag1d9azE=TePh3JRgi-ZiN3B1unbFxorw@mail.gmail.com>
References: <CAPgLHd-bG936v1J73Ag1d9azE=TePh3JRgi-ZiN3B1unbFxorw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, February 26, 2013 10:29:34 AM Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> This removes an open coded simple_open() function and
> replaces file operations references to the function
> with simple_open() instead.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks for this.

Vladimir.
