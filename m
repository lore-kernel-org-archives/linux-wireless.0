Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:48995 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZHSON2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 10:13:28 -0400
Date: Wed, 19 Aug 2009 15:13:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: marcel@holtmann.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] dell-laptop: poll the rfkill hard-block
Message-ID: <20090819141322.GA15937@srcf.ucam.org>
References: <4A8C0623.8030808@tuffmail.co.uk> <1250690811-21203-5-git-send-email-alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250690811-21203-5-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 03:06:51PM +0100, Alan Jenkins wrote:
> This is controlled by a hardware switch, so we should poll it in order
> to pick up changes.  (There does not appear to be an interrupt or any
> other notification mechanism).

With the exception of this one they all look fine - I'm moving house 
next week and won't have access to any Dell hardware for over a month, 
so if anyone else could confirm that these work that would be excellent.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
