Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2123 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbYG3E1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 00:27:23 -0400
Date: Tue, 29 Jul 2008 13:46:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Please do not pull 2.6.27-rc1 into wireless-testing
Message-ID: <20080729174623.GA4923@tuxdriver.com> (sfid-20080730_062726_108435_187BC920)
References: <488E9FB8.3080804@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <488E9FB8.3080804@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 28, 2008 at 11:42:32PM -0500, Larry Finger wrote:

> As stated in the subject, please do not update wireless-testing with 
> 2.6.27-rc1, at least for a while. In the thread that starts at  
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/18423, I 
> found that commit 175f9c1bba9b825d2 breaks wireless, at least for b43. 
> Until that is fixed, I think wireless-testing should remain at 2.6.26.

Have you tried the patches Johannes sent today?  Do they help the
situation?

John
-- 
John W. Linville
linville@tuxdriver.com
