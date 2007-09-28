Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:35076 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbXI1LlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 07:41:04 -0400
Received: by py-out-1112.google.com with SMTP id u77so5163406pyb
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2007 04:41:03 -0700 (PDT)
Message-ID: <1ba2fa240709280441s3eceac51x74a8bb8e422808f2@mail.gmail.com>
Date: Fri, 28 Sep 2007 13:41:03 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi scan question
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1190815228.4204.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1190815228.4204.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/26/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> When iwlwifi scans in firmware, which MAC address does it use? What if
> you've added multiple virtual interfaces as you said you could support?
>
Scanning is STA feature so only one MAC address is used in that case.
namely iwl_rxon_cmd.node_addr
Do you know any use case to support STA with multiple MAC addresses?
Tomas

> johannes
>
>
