Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:49690 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab3HMLjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 07:39:41 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wireless-regdb@lists.infradead.org
Subject: Re: [wireless-regdb] [PATCH 00/53] wireless-regdb: latest updates
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Date: Tue, 13 Aug 2013 13:13:08 +0200
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com> (Luis
	R. Rodriguez's message of "Tue, 16 Jul 2013 19:17:49 -0700")
Message-ID: <87mwolc08r.fsf@nemi.mork.no> (sfid-20130813_133945_338190_5EF36DDF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:

> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>
> I saw one comment posted about the Indonesia patch, I fixed that.
> I also then ran some sanity tests with a new reglib addition
> wich I recently posted. This helped find two cases which
> required disabling VHT80 for two countries on a specific band.
> One was for US for 5690 and another for TW for 5290. In both cases
> the reason is due to the fact that the only way to use VHT80 is
> to combine two frequency ranges together that are contiguous and
> apply the most restrictive band rules for that range. We don't support
> this yet so just disable VHT80 in both cases. In the US case this
> also seems to be the preferred ruling.

Hello,

Out of personal interest I'm wondering why you excluded Norway and
Iceland from this series?  As EEA [1] members they pretty much follow
all relevant EU regulations, like for example the R&TTE directive.  And
the CEPT documents should also be pretty clear wrt VHT80 support.


[1] http://en.wikipedia.org/wiki/European_Economic_Area



Bjørn
