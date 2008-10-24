Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:53334 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYJXSYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 14:24:16 -0400
Received: by el-out-1112.google.com with SMTP id z25so473249ele.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2008 11:24:14 -0700 (PDT)
Message-ID: <43e72e890810241124k359856d5g80ebc3cebc5c428@mail.gmail.com> (sfid-20081024_202420_376432_48A993ED)
Date: Fri, 24 Oct 2008 11:24:13 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1224872328.7536.67.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1224585110.5521.8.camel@johannes.berg>
	 <1224816184.2917.162.camel@debian.sh.intel.com>
	 <1224841176.6002.124.camel@johannes.berg>
	 <1224872328.7536.67.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2008 at 11:18 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Can the mac80211 just track if userspace has set a regulatory
> domain and then enforce it.

yeap, when initiator == CORE

  Luis
