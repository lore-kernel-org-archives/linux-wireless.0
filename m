Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:27343 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYLSTcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 14:32:54 -0500
Received: by fg-out-1718.google.com with SMTP id 19so450702fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 11:32:53 -0800 (PST)
Message-ID: <f6ca9fed0812191132h2f76ce40id20c52bdb6e0681c@mail.gmail.com> (sfid-20081219_203258_227537_0BC6BCF9)
Date: Fri, 19 Dec 2008 20:32:53 +0100
From: drago01 <drago01@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH 00/43] iwl3945 merges into iwlagn (Dec 19)
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 3:37 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> Hi John,
>
> Here is the first batch for the iwl3945 -> iwlagn merge. This is for
> post .29 kernel.

Well it doesn't really matter but wouldn't it make sense to rename the
driver back to iwlwifi ? (as 3945 does not support n mode)
