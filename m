Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:56089 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933347Ab3DDIB5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 04:01:57 -0400
Message-ID: <515D336B.8080502@neratec.com> (sfid-20130404_100200_837799_789A83CE)
Date: Thu, 04 Apr 2013 10:01:47 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: fix DFS detector called in softirq context
References: <1364899908-7433-1-git-send-email-zefir.kurtisi@neratec.com> <20130403174606.GA31358@tuxdriver.com>
In-Reply-To: <20130403174606.GA31358@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2013 07:46 PM, John W. Linville wrote:
> It looks like this could apply to 3.9 -- should it be applied there?
> 

Yes it should. Thanks.
