Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64928 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058Ab2BVIhv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 03:37:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
Date: Wed, 22 Feb 2012 10:37:50 +0200
Message-ID: <CAOJsxLFCLMFh7QQFQ+rsK3vr+oqvdoHifuEY5=oQASXZF6sbGA@mail.gmail.com> (sfid-20120222_093809_893377_9E9B4F44)
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 24, 2012 at 3:36 AM, Norbert Preining <preining@logic.at> wrote:
> long time ago we had a long discussion about iwlagn regressions in 3.1.0
> Up to 3.2 I still have regular problems on the university network
> with stuck iwl driver not even realizing that nothing goes out or in.
>
> Today I switched to 3.3-rc1 to see it is getting even worse, now on my
> home network I get stuck queue and no connection:

I'm seeing the same thing with my home network as well with 3.3-rc3.
Is there a fix in the pipeline for 3.3 final or do you want me to
bisect which commits to revert?

                                Pekka
