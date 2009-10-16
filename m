Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41587 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZJPXPU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 19:15:20 -0400
Received: by fxm18 with SMTP id 18so3014687fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 16:15:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255728358-29976-11-git-send-email-reinette.chatre@intel.com>
References: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
	 <1255728358-29976-11-git-send-email-reinette.chatre@intel.com>
Date: Sat, 17 Oct 2009 01:15:24 +0200
Message-ID: <1ba2fa240910161615h75a74e13u8a31c3e49eae234a@mail.gmail.com>
Subject: Re: [PATCH 10/10] iwlwifi: rework for static power save
From: Tomas Winkler <tomasw@gmail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  #include "iwl-commands.h"
>
> +#define IWL_CONN_LISTEN_INTERVAL       10

There is already IWL_CONN_MAX_LISTEN_INTERVAL; defined

Thanks
Tomas
