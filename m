Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:32824 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbbJMSiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 14:38:05 -0400
Received: by iodv82 with SMTP id v82so31024202iod.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2015 11:38:04 -0700 (PDT)
Date: Tue, 13 Oct 2015 13:37:03 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Karl =?utf-8?Q?M=C3=B6ller?= <karl@excors.net>
Subject: Re: [PATCH] wireless-regdb: Update ZA rules for 5490-5710 MHz
Message-ID: <20151013183703.GA50632@ubuntu-hedt> (sfid-20151013_203812_758856_6C12F2BD)
References: <1444053722-33852-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1444053722-33852-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 05, 2015 at 09:02:02AM -0500, Seth Forshee wrote:
> The Radio Frequency Spectrum Regulations 2015 [1] drops the
> requirement for DFS and TPC in the 5490-5710 MHz range. Update
> the database to remove DFS for this range and remove the 3dB drop
> in the transmit power limit for TPC.
> 
> [1] http://www.ellipsis.co.za/wp-content/uploads/2014/12/Radio-Frequency-Spectrum-Regulations-2015.pdf
> 
> Cc: Karl Möller <karl@excors.net>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Applied.
