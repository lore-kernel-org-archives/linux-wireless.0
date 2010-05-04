Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:3548 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932993Ab0EDTN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 15:13:59 -0400
Message-ID: <4BE071F5.3020405@gmail.com>
Date: Tue, 04 May 2010 21:13:57 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 2/4] rt2x00: Enable RT30xx by default.
References: <282593.4376.qm@web56802.mail.re3.yahoo.com>
In-Reply-To: <282593.4376.qm@web56802.mail.re3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/10 21:09, Walter Goldens wrote:
> 
>> Now that RT30xx support is at the
>> same level as RT28xx support we can enable
>> these devices by default.
> 
> Shouldn't support for RT30xx be enabled by default for compat-wireless as well?
> 

compat-wireless will be updated automatically once wireless-next-2.6 gets merged
into linux-next. Just have a bit of patience.

---
Gertjan.
