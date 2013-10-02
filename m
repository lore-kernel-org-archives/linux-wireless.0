Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab3JBJW5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:22:57 -0400
Date: Wed, 2 Oct 2013 11:19:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Matt Chen <machen@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, kvoz123@gmail.com
Subject: Re: iwlegacy: iwl4965 reload firmware issue.
Message-ID: <20131002091935.GE1442@redhat.com> (sfid-20131002_112301_139596_BFBE06B6)
References: <CALx5=V_voRtb_e=9BFhNmt7rLO4v5iQKdZ0NCyZATtYCOUh7JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALx5=V_voRtb_e=9BFhNmt7rLO4v5iQKdZ0NCyZATtYCOUh7JA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 01, 2013 at 04:17:44PM +0800, Matt Chen wrote:
> The restart path is through il_irq_handle_error(il). My question is if
> this is a firmware issue, driver issue or hardware issue ?

Most likely driver issue, microcode error usually mean that driver provide 
wrong values to the firmware or differently abuse firmware work.

Stanislaw
