Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37772 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYIBTpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 15:45:46 -0400
Date: Tue, 2 Sep 2008 15:41:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	bugme-daemon@bugzilla.kernel.org, karthikg@deccantechnosoft.com
Subject: Re: [Bugme-new] [Bug 11483] New: Raw socket tx/rx program for
	"ath0" shows "sending: : No buffer space available"
Message-ID: <20080902194114.GD3050@tuxdriver.com> (sfid-20080902_214550_414388_E25AA9EF)
References: <bug-11483-10286@http.bugzilla.kernel.org/> <20080902122938.f3858d6d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080902122938.f3858d6d.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 02, 2008 at 12:29:38PM -0700, Andrew Morton wrote:
> 
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> I assume this is an atheros driver problem, not a core networking
> problem..

ath_pci -- looks like madwifi to me...

-- 
John W. Linville
linville@tuxdriver.com
