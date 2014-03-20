Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbaCTL1F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 07:27:05 -0400
Date: Thu, 20 Mar 2014 11:16:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@GMAIL.COM>
Subject: Re: [RFC/RFT 0/9] iwlegacy rework rx allocation
Message-ID: <20140320101604.GA5989@redhat.com> (sfid-20140320_122711_910235_AFBDFB22)
References: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 05, 2014 at 01:13:25PM +0100, Stanislaw Gruszka wrote:
> Those patches replace compicated rx allocation algoritm with
> simple one which always assure we have RX buffers ready for 
> firmware. This fix long standing problem with microcode errors
> when system is under load.
> 
> I tested them only on 4965.  

Unfortunately they do not solve firmware error happened randomly, which
I hoped they solve. I need more testing of that issue. For now I pushed
those patches and bunch of others at https://github.com/sgruszka/iwlegacy

Stanislaw 
