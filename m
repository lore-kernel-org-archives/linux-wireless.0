Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39561 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaJaUPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 16:15:14 -0400
Date: Fri, 31 Oct 2014 16:07:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 2/3] ath: use seq_file api for ath9k debugfs files
Message-ID: <20141031200704.GE3768@tuxdriver.com> (sfid-20141031_211524_730501_0B7E39A4)
References: <1414498752-9746-1-git-send-email-arend@broadcom.com>
 <1414498752-9746-3-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414498752-9746-3-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2014 at 01:19:11PM +0100, Arend van Spriel wrote:
> The debugfs files that are defined in debug.c which are read-only
> and using a simple_open as .open file operation have been modified
> to use the single_open seq_file API. This simplifies the read
> functions defining the file contents.
> 
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
