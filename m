Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44398 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab2HFRxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 13:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <decee2f9df27aefc9e57ac1a18855f874278ff53.1343885909.git.steven@steven676.net>
References: <ab6d95605ad827f0c7f973d47656a897ffe17fb7.1343885909.git.steven@steven676.net>
 <decee2f9df27aefc9e57ac1a18855f874278ff53.1343885909.git.steven@steven676.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 6 Aug 2012 10:53:21 -0700
Message-ID: <CAB=NE6WH-32k8KNtxYx3=LN8WiZrEswX5UgBd2zyv4u6sz+Xiw@mail.gmail.com> (sfid-20120806_195346_380901_605F132F)
Subject: Re: [PATCH 2/2] compat-wireless: driver-select: update after
 introduction of CONFIG_WL_TI
To: Steven Luo <steven@steven676.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 1, 2012 at 10:44 PM, Steven Luo <steven@steven676.net> wrote:
> The introduction of CONFIG_WL_TI broke selecting the TI drivers using
> driver-select.  Fix this, and while we're at it, teach the script about
> wl18xx as well.
>
> Signed-off-by: Steven Luo <steven@steven676.net>

Applied and pushed these two, thanks!

 Luis
