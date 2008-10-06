Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:41468 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYJFOmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 10:42:14 -0400
Received: by gxk9 with SMTP id 9so4988371gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 07:42:13 -0700 (PDT)
Message-ID: <1ba2fa240810060742y7d0d4d24w984fe55be178e6d1@mail.gmail.com> (sfid-20081006_164217_423944_12363C42)
Date: Mon, 6 Oct 2008 16:42:13 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Rami Rosen" <ramirose@gmail.com>
Subject: Re: [PATCH 2/2] iwlwifi: fix compliation warning in iwl-scan.c when CONFIG_IWLWIFI_DEBUG is not set.
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com
In-Reply-To: <eb3ff54b0810060659n7d93a9fcla1301fa68a8a23a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0810060659n7d93a9fcla1301fa68a8a23a5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 6, 2008 at 3:59 PM, Rami Rosen <ramirose@gmail.com> wrote:
> When CONFIG_IWLWIFI_DEBUG is not set and CONFIG_IWLWIFI is set,
> we get this compilation warning:
> wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-scan.c:92: warning:
> 'iwl_escape_essid' defined but not used
>
> This patch (against wireless-next-2.6 tree) fixes it.
>
I believe there is queued patch that removes this code completely
Tomas
