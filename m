Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:50111 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaHQDSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2014 23:18:07 -0400
Received: by mail-la0-f52.google.com with SMTP id b17so3452757lan.11
        for <linux-wireless@vger.kernel.org>; Sat, 16 Aug 2014 20:18:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140815102354.96039202E9@platinum.linx.net>
References: <20140815102354.96039202E9@platinum.linx.net>
Date: Sat, 16 Aug 2014 23:18:05 -0400
Message-ID: <CANUX_P1sZCvysK+jhNBQibH3QoDNOrK6tb=oaXpk56JKbWJpQA@mail.gmail.com> (sfid-20140817_051811_453178_A8D91276)
Subject: Re: [PATCH] iwlwifi: Correctly deal with monolithic kernels
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Tony Vroon <tony@linx.net>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 15, 2014 at 6:23 AM, Tony Vroon <tony@linx.net> wrote:
> Post 3.16 any non-modular kernel ends up with IWLWIFI selectable but neither of the
> underlying required DVM or MVM drivers. This violates the principle of least
> astonishment.
> If IWLWIFI only supports a modular system the main IWLWIFI should depend on m as well.
> Otherwise, removing the "depends on m" allows monolithic kernels to work once again.
>
> Signed-off-by: Tony Vroon <tony@linx.net>
>

Someone else posted the exact same patch. thanks.
