Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3346 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab2DWRnm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 13:43:42 -0400
Message-ID: <4F9594C1.5060000@broadcom.com> (sfid-20120423_194415_990510_97182080)
Date: Mon, 23 Apr 2012 10:43:29 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Eldad Zack" <eldad@fogrefinery.com>,
	"John W. Linville" <linville@tuxdriver.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [brcmsmac] "INTERMEDIATE but not AMPDU" only when
 tracing
References: <1335048484-5925-1-git-send-email-eldad@fogrefinery.com>
In-Reply-To: <1335048484-5925-1-git-send-email-eldad@fogrefinery.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/21/2012 03:48 PM, Eldad Zack wrote:
>  From the code comment I understand that this something that can - and does, quite frequently - happen.
> This patch demotes the message to the trace level.
>
> Signed-off-by: Eldad Zack<eldad@fogrefinery.com>

Thx Eldad,

Acked-by: Franky Lin<frankyl@broadcom.com>

