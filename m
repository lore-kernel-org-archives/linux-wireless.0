Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53669 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab2K0QWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 11:22:46 -0500
Date: Tue, 27 Nov 2012 10:22:40 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH v2 09/22] brcm80211: Allow trace support to be enabled
 separately from debug
Message-ID: <20121127162240.GB21412@thinkpad-t410> (sfid-20121127_172250_011329_0817633E)
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-10-git-send-email-seth.forshee@canonical.com>
 <50AA9789.9070807@broadcom.com>
 <20121119211511.GB20301@thinkpad-t410>
 <50AAA275.5030609@broadcom.com>
 <20121119213300.GC20301@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121119213300.GC20301@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 03:33:00PM -0600, Seth Forshee wrote:
> > That seems reasonable. Have you any significant impact in throughput
> > with tracing enabled?
> 
> I've really only tested with tracing enabled. Compared to before this
> patch series the peak performance (as measured with iperf using a TCP
> connection) is close enough that any differences would be lost in the
> noise, and average performance is better due to the transfer rate being
> more stable. I'll run some tests with and without tracing enabled to
> compare the results. I may not get to it before next week though due to
> the Thanksgiving holiday here in the US.

I've done some unscientific comparison between builds with and without
BRCM_TRACING enabled. UDP iperf performance was identical, both send and
receive. With TCP the difference in throughput was small, definitely
within the range of noise for my small sample size. So as far as I can
tell enabling tracing has a negligible impact on throughput.

Seth

