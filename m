Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44856 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab0LWOPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 09:15:07 -0500
Date: Thu, 23 Dec 2010 09:00:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Eric Appleman <erappleman@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi: Intel 3945ABG speed issues finally identified.
Message-ID: <20101223140045.GA3316@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20101223T093853-190@post.gmane.org>
 <loom.20101223T071403-99@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 23, 2010 at 06:15:18AM +0000, Eric Appleman wrote:
> I spent most of the day bisecting and testing numerous kernels and my work has
> finally paid off.
> 
> I've found 2 candidate commits.
> 
> a6866ac93e6cb68091326e80b4fa4619a5957644
> 1402364162afbaac1b8a74ee21aeb013e817ac7d
> 
> iwl3945 definitely broke between 2.6.35-rc2 and -rc3.

On Thu, Dec 23, 2010 at 08:39:32AM +0000, Eric Appleman wrote:
> 2 more commits that I missed
> 
> 7d47618a2ade0cb6d8a0b2597029c383c1662fa0
> 6db6340c42d027b6364d49fa99d69019aca24de4

Did you revert any/all of these patches?  Can you quantify what effect
that had?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
