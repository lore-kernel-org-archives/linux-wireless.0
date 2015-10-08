Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbbJHKMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 06:12:53 -0400
Date: Thu, 8 Oct 2015 11:00:52 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 01/10] staging: wilc1000: remove typedef from tstrWID
Message-ID: <20151008100052.GA16918@kroah.com> (sfid-20151008_121256_090034_DE9775C9)
References: <1444124541-5663-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444124541-5663-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 06, 2015 at 06:42:12PM +0900, Tony Cho wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch removes typedef from the struct tstrWID and
> rename it to wid.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c |  2 +-
>  drivers/staging/wilc1000/coreconfigurator.h |  7 +--
>  drivers/staging/wilc1000/host_interface.c   | 92 ++++++++++++++---------------
>  3 files changed, 50 insertions(+), 51 deletions(-)

This series also did not apply :(
