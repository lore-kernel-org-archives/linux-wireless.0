Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751747AbeDJLAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 07:00:16 -0400
Date: Tue, 10 Apr 2018 13:00:13 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dusan Bruncko <dusan.bruncko@cern.ch>
Cc: linux-wireless@vger.kernel.org, centos-devel@centos.org
Subject: Re: iwlwifi-7265-ucode-25.30.14.0.tgz. in Centos 7
Message-ID: <20180410110012.GB4284@redhat.com> (sfid-20180410_130019_537915_AE11ABAE)
References: <fe3605be-8ce1-ee6f-7ea2-7f736f5493fb@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fe3605be-8ce1-ee6f-7ea2-7f736f5493fb@cern.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 08, 2018 at 08:58:35AM +0200, Dusan Bruncko wrote:
> My problem is following: This firmware was created for kernel 4.2+,
> but I am using
> Centos 7 with kernels a la 3.10. Therefore I see during booting and

Wireless stack and drivers are regularly updated in Centos kernel,
(for example latest release has wireless drivers from 4.14)
and should match firmware provided in the distribution.

Regards
Stanislaw
