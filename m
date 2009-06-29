Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63177 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZF2MoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 08:44:02 -0400
MIME-Version: 1.0
In-Reply-To: <4A48A196.3060409@tuffmail.co.uk>
References: <4A48A196.3060409@tuffmail.co.uk>
Date: Mon, 29 Jun 2009 14:44:02 +0200
Message-ID: <71cd59b00906290544y71061c31p597efcb6c8ceeabd@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: fix hot-unplug on resume
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux acpi <linux-acpi@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 29, 2009 at 1:12 PM, Alan
Jenkins<alan-jenkins@tuffmail.co.uk> wrote:
> The patch below fixes a regression introduced by the rfkill rewrite.
> Please consider it for inclusion in 2.6.31 via the ACPI tree.
>
> Thanks
> Alan

Hi Len,

Please merge this patch in ACPI tree.
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
