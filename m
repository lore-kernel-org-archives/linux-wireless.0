Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:4759 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYJGH6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 03:58:53 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2674698fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2008 00:58:51 -0700 (PDT)
Message-ID: <1ba2fa240810070058w5490ef17p6ff6f099e5907aab@mail.gmail.com> (sfid-20081007_095856_300331_EFCEBA59)
Date: Tue, 7 Oct 2008 09:58:50 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Rami Rosen" <ramirose@gmail.com>
Subject: Re: [PATCH ] [RESEND] iwlwifi: fix compilation warning when CONFIG_IWLWIFI_DEBUG is not set.
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com
In-Reply-To: <eb3ff54b0810070050m3256bffao6d566baa41560ae7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0810070050m3256bffao6d566baa41560ae7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 7, 2008 at 9:50 AM, Rami Rosen <ramirose@gmail.com> wrote:
> When CONFIG_IWLWIFI_DEBUG is not set and CONFIG_IWLWIFI is set,
> we get this compilation warning:
> /wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-agn-rs.c: In
> function 'rs_free_sta':
> /wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-agn-rs.c:2425:
> warning: unused variable 'priv'
>
> This patch fixes it by adding __maybe_unused attribute.
>
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
>
ACK
