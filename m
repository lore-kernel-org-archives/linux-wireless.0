Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37449 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964952Ab3FSSpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 14:45:11 -0400
Date: Wed, 19 Jun 2013 14:38:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: rlwkayaker <rlwkayaker@charter.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Howto remove rfkill from kernel
Message-ID: <20130619183839.GD12079@tuxdriver.com> (sfid-20130619_204526_923771_91779EC0)
References: <20130619133638.3d183a00@compuzoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130619133638.3d183a00@compuzoo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 19, 2013 at 01:36:38PM -0400, rlwkayaker wrote:
> The rfkill "feature" has rendered the internal wireless of my
> Averatec 3260 laptop unusable.  It works fine with earlier
> kernels without this "feature".  How do I remove the rfkill
> "feature" from a custom built kernel?

The rfkill "feature" has been in the kernel for years.  Exactly what
kernels are you using?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
