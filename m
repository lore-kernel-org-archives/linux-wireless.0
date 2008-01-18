Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:49298 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746AbYARX0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 18:26:40 -0500
Received: by py-out-1112.google.com with SMTP id u52so1776522pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2008 15:26:39 -0800 (PST)
Message-ID: <43e72e890801181526gaf5960fr5c66b97155e8bfda@mail.gmail.com> (sfid-20080118_232647_708108_1794F5DA)
Date: Fri, 18 Jan 2008 18:26:38 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 1/4] ath5k: debug level improvements
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20080118125018.6342.94435.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125018.6342.94435.stgit@one>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 18, 2008 7:50 AM, Bruno Randolf <bruno@thinktube.com> wrote:

> +       { ATH5K_DEBUG_ANY,      "any",          "show any debug level" },

Very cool, can we call this "all" instead though, and "show all debug levels" ?

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
