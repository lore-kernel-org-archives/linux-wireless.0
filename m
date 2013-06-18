Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:40827 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab3FRL05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 07:26:57 -0400
Message-ID: <51C043FE.6050108@lri.fr> (sfid-20130618_132700_567675_533459D8)
Date: Tue, 18 Jun 2013 13:26:54 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Antonio Quartulli <ordex@autistici.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Revert "mac80211: in IBSS use the Auth frame to trigger
 STA reinsertion"
References: <1371552313-3581-1-git-send-email-ordex@autistici.org>
In-Reply-To: <1371552313-3581-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/06/2013 12:45, Antonio Quartulli wrote:
> -	if (auth && !sdata->u.ibss.auth_frame_registrations) {

The sole purpose of the auth_frame_registrations field is to be checked by this code.
The field and the code maintaining this field can be removed now.
