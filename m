Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:35916 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbeIDQct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:32:49 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Luca Coelho <luca@coelho.fi>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH v2 9/9] mac80211: Don't wake up from PS for offchannel TX
Date: Tue, 04 Sep 2018 14:07:54 +0200
Message-ID: <8536772.7SmJXvWjMu@bentobox> (sfid-20180904_140803_195206_132CDBCD)
In-Reply-To: <20180904114055.1429-10-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi> <20180904114055.1429-1-luca@coelho.fi> <20180904114055.1429-10-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1858238.n2RApS7eac"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1858238.n2RApS7eac
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Dienstag, 4. September 2018 14:40:55 CEST Luca Coelho wrote:
> )
> Sender: linux-wireless-owner@vger.kernel.org
> Precedence: bulk
> List-ID: <linux-wireless.vger.kernel.org>
> X-Mailing-List: linux-wireless@vger.kernel.org

Looks like the SMTP headers are broken in all your patches. Here the 
interesting part (as received by me):

    [...]
    X-SA-Exim-Scanned: Yes (on 
    
    )
    Sender: linux-wireless-owner@vger.kernel.org
    Precedence: bulk
    List-ID: <linux-wireless.vger.kernel.org>
    X-Mailing-List: linux-wireless@vger.kernel.org

Kind regards,
	Sven
--nextPart1858238.n2RApS7eac
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAluOdZoACgkQXYcKB8Em
e0bSAxAArMHJzTMOBEMD7CsCEqwD80QHpQ2cidSOeJugmbqPuwbLxVJmZ0qhOY+m
bXxUaOrraNIUH+h8uP9jier9JIARg8tXJZtY7qu4OhSdGGs2M1Ox2v5BXloLh1Mk
WU3MF56wZUrfi6jaUHd/ZeD6zt7IEJ8s2JciTVAR7kiyjZn+HVYxWR9KGh4ToJjU
LFsAu5iiNP27YBsxKpyfHixJ6tNXAlTqHXybG5mIZ5dFMJNWHlW6ib3ybfGknoxJ
NlE/LMRKozLL8NCO5IapXQQXFjWvvJ8sEiFLpbm0L/agkWbspoyPT2Vp33UtRvfm
tg7Tq9J7mpi7S1Wa3LhMVHObLbCqhuvy0dUR63QN7i/CTSFPTtDrz/v/kXpWLCoZ
2gamO/kVlLkpFXwxNuu3eLJsSa61z2aPJYz8z2OvhNKAkZDRoqZV2TOLNDprqf4e
hRGpPecJRIb/Fib7Mswo0lT8dNYJ3Q/CythZDtwDZl34aN9cHmse7T5SBfzZs2TI
BsUJH9UIu6Bun565K2FuBgpLUyi+/+lCaLtli/l8L3S/vfF+e7R/cWHafeY7k/8N
lmYo1esS1+j/XRy5Ig0Qqw9jkPQgyQ+/6fiIK2Mi3EeLWZQzEfedqKrFXLw9B5ha
+DRMUzxn/tp/3l4TPNraLjaYks8pmzN3S8L7SQi7ouh4EHN9mqs=
=rjYu
-----END PGP SIGNATURE-----

--nextPart1858238.n2RApS7eac--
