Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:43074 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbYF3I4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 04:56:34 -0400
Received: by an-out-0708.google.com with SMTP id d40so276164and.103
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 01:56:33 -0700 (PDT)
Message-ID: <43e72e890806300156g6b3e4f81ld371feec99efe022@mail.gmail.com> (sfid-20080630_105642_015203_750C4255)
Date: Mon, 30 Jun 2008 01:56:33 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/1] compat-wireless: fix compilation of mac80211
Cc: compat-masters@lists.madwifi.org, linux-wireless@vger.kernel.org
In-Reply-To: <1214815465-529-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1214815465-529-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 1:44 AM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> This fix the compilation of mac80211 if it's not enabled
> in the target kernel.
> compat-wireless everything is compiled as module
>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Applied, thanks.

  Luis
