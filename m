Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48203 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbcBHRSp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 12:18:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 08 Feb 2016 18:18:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?UTF-8?Q?Jo?= =?UTF-8?Q?=C3=A3o_Paulo_Rechi_Vita?=
	<jprvita@endlessm.com>
Subject: Re: [PATCH 8/9] rfkill: Userspace control for airplane mode
In-Reply-To: <F8D31DB3-94AF-47CC-8091-7B6478983B53@holtmann.org>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
 <1454946096-9752-9-git-send-email-jprvita@endlessm.com>
 <F8D31DB3-94AF-47CC-8091-7B6478983B53@holtmann.org>
Message-ID: <186fb54a85083fe6aebe83763aa029c4@sipsolutions.net> (sfid-20160208_181908_362794_18018A83)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-02-08 17:20, Marcel Holtmann wrote:

> as explained in an earlier response, the concept Airplane Mode seems
> to be imposing policy into the kernel. Do we really want have this as
> a kernel exposed API.

This patch is the one that *solves* that problem ... please read it more 
carefully?

johannes
