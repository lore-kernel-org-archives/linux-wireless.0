Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:21689 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbZA0Jeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 04:34:44 -0500
Received: by mu-out-0910.google.com with SMTP id g7so4422007muf.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 01:34:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233047705.4012.12.camel@johannes.local>
References: <1233047705.4012.12.camel@johannes.local>
Date: Tue, 27 Jan 2009 11:34:42 +0200
Message-ID: <1ba2fa240901270134x50b4daej9fb600ac1d8311ef@mail.gmail.com> (sfid-20090127_103452_836416_20E1C6C2)
Subject: Re: iwlwifi warnings
From: Tomas Winkler <tomasw@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 27, 2009 at 11:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
> 'iwl3945_pci_resume':
> drivers/net/wireless/iwlwifi/iwl3945-base.c:6319: warning: ignoring
> return value of 'pci_enable_device', declared with attribute
> warn_unused_result
>
> drivers/net/wireless/iwlwifi/iwl-agn.c: In function 'iwl_pci_resume':
> drivers/net/wireless/iwlwifi/iwl-agn.c:4128: warning: ignoring return
> value of 'pci_enable_device', declared with attribute warn_unused_result
>
> drivers/net/wireless/iwlwifi/iwl-tx.c: In function 'iwl_tx_queue_alloc':
> drivers/net/wireless/iwlwifi/iwl-tx.c:302: warning: format '%zd' expects
> type 'signed size_t', but argument 4 has type 'u32'

Patch already queued.
Tomas
