Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:10171 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbYJ0KaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 06:30:05 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1988257wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 03:30:04 -0700 (PDT)
Message-ID: <1ba2fa240810270330u15e3ce04y9d077904f48e04e7@mail.gmail.com> (sfid-20081027_113012_019320_61FFB50F)
Date: Mon, 27 Oct 2008 12:30:04 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: build warnings
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chr <chunkeey@web.de>, mcgrof <mcgrof@gmail.com>
In-Reply-To: <1224923050.27353.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224923050.27353.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 25, 2008 at 10:24 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> just FYI in case you haven't seen them. the p54 one looks like a genuine
> problem.
>
> drivers/net/wireless/iwlwifi/iwl-scan.c:69: warning: 'scan_tx_ant' defined but not used

Strange. This variable was removed in 'iwlwifi: unify tx antenna toggling' patch
Tomas
