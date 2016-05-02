Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35638 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbcEBNnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 09:43:52 -0400
Received: by mail-oi0-f41.google.com with SMTP id x19so189388017oix.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2016 06:43:52 -0700 (PDT)
Date: Mon, 2 May 2016 08:43:50 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Maximilian Engelhardt <engelhardt@perisens.de>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	maxi@daemonizer.de
Subject: Re: wireless-regdb: Update regulatory references for Germany (DE)
Message-ID: <20160502134350.GD2714@ubuntu-hedt> (sfid-20160502_154355_623735_61CEED10)
References: <1627007.Hvd6lR1COR@perisens15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1627007.Hvd6lR1COR@perisens15>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 25, 2016 at 03:09:48PM +0200, Maximilian Engelhardt wrote:
> Hi,
> 
> The "Frequenznutzungsplan" is not really a good reference as it's a list
> of all frequency allocations and does only list basic information about
> the allocation. This patch changes the comments to reference directly
> the corresponding documents which provide all information about the
> allocation.
> 
> This patch does only change comments, all entries have been left
> unchanged. However the entries have been verified to match the mentioned
> documents.
> 
> This patch is based on my last path that adds the short range devices band for 
> Germany.
> 
> Thanks,
> Maxi
> 
> 
> Signed-off-by: Maximilian Engelhardt <engelhardt@perisens.de>

Applied, thanks.
